#!/usr/bin/env bash

# Transfer it using this
# sudo mv ani-cli.sh /usr/local/bin/ani-cli

readonly USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0"
readonly API_REFERER="https://allmanga.to"
readonly API_BASE="allanime.day"
readonly API_URL="https://api.${API_BASE}"
readonly DEFAULT_MODE="sub"
DOWNLOAD_DIR="${ANI_CLI_DOWNLOAD_DIR:-.}"

# ==============================================================================
# UTILITY FUNCTIONS
# ==============================================================================

die() {
  printf "\33[2K\r\033[1;31m%s\033[0m\n" "$*" >&2
  exit 1
}

check_dependencies() {
  local dep
  for dep in "$@"; do
    if ! command -v "${dep%% *}" >/dev/null 2>&1; then
      die "Missing non-standard tool: \"${dep%% *}\" not found. Please install it."
    fi
  done
}

render_menu() {
  fzf --reverse --cycle --prompt "$1"
}

select_menu_item() {
  local prompt_text="$1"
  local stdin_data=$(cat -)

  [[ -z "${stdin_data}" ]] && return 1

  local line_count=$(printf "%s\n" "${stdin_data}" | awk 'END {print NR}')
  if [[ "${line_count}" -eq 1 ]]; then
    printf "%s\n" "${stdin_data}" | cut -f2,3
    return 0
  fi

  local selected_id=$(
    printf "%s\n" "${stdin_data}" \
      | awk -F'\t' '{print $1 " " $3}' \
      | render_menu "${prompt_text}" \
      | awk '{print $1}'
  )

  [[ -z "${selected_id}" ]] && exit 1
  printf "%s\n" "${stdin_data}" | awk -v id="${selected_id}" '$1 == id' | cut -f2,3 || exit 1
}

# ==============================================================================
# SCRAPING
# ==============================================================================

fetch_anime_search_results() {
  local query="$1"
  local graphql_query='query( $search: SearchInput $limit: Int $page: Int $translationType: VaildTranslationTypeEnumType $countryOrigin: VaildCountryOriginEnumType ) { shows( search: $search limit: $limit page: $page translationType: $translationType countryOrigin: $countryOrigin ) { edges { _id name availableEpisodes __typename } }}'
  local json_payload="variables={\"search\":{\"allowAdult\":false,\"allowUnknown\":false,\"query\":\"${query}\"},\"limit\":40,\"page\":1,\"translationType\":\"${DEFAULT_MODE}\",\"countryOrigin\":\"ALL\"}"

  curl -e "${API_REFERER}" -s -G "${API_URL}/api" \
    --data-urlencode "${json_payload}" \
    --data-urlencode "query=${graphql_query}" \
    -A "${USER_AGENT}" \
    | sed 's|Show|\n| g' \
    | sed -nE "s|.*_id\":\"([^\"]*)\",\"name\":\"(.+)\",.*${DEFAULT_MODE}\":([1-9][^,]*).*|\1\t\2 (\3 episodes)|p" \
    | tr -d '\\"'
}

fetch_episode_list() {
  local show_id="$1"
  local graphql_query='query ($showId: String!) { show( _id: $showId ) { _id availableEpisodesDetail }}'
  local json_payload="variables={\"showId\":\"${show_id}\"}"

  curl -e "${API_REFERER}" -s -G "${API_URL}/api" \
    --data-urlencode "${json_payload}" \
    --data-urlencode "query=${graphql_query}" \
    -A "${USER_AGENT}" \
    | sed -nE "s|.*${DEFAULT_MODE}\":\[([0-9.\",]*)\].*|\1|p" \
    | tr ',"' '\n' \
    | awk 'NF' \
    | sort -n
}

decrypt_provider_id() {
  local encoded=$(printf "%s" "$3" | sed -n "$2" | sed -n '1p' | awk -F':' '{print $2}' | sed 's/../&\n/g')
  printf "%s" "${encoded}" | sed \
    -e 's/^79$/A/g' -e 's/^7a$/B/g' -e 's/^7b$/C/g' -e 's/^7c$/D/g' -e 's/^7d$/E/g' -e 's/^7e$/F/g' -e 's/^7f$/G/g' -e 's/^70$/H/g' \
    -e 's/^71$/I/g' -e 's/^72$/J/g' -e 's/^73$/K/g' -e 's/^74$/L/g' -e 's/^75$/M/g' -e 's/^76$/N/g' -e 's/^77$/O/g' -e 's/^68$/P/g' \
    -e 's/^69$/Q/g' -e 's/^6a$/R/g' -e 's/^6b$/S/g' -e 's/^6c$/T/g' -e 's/^6d$/U/g' -e 's/^6e$/V/g' -e 's/^6f$/W/g' -e 's/^60$/X/g' \
    -e 's/^61$/Y/g' -e 's/^62$/Z/g' -e 's/^59$/a/g' -e 's/^5a$/b/g' -e 's/^5b$/c/g' -e 's/^5c$/d/g' -e 's/^5d$/e/g' -e 's/^5e$/f/g' \
    -e 's/^5f$/g/g' -e 's/^50$/h/g' -e 's/^51$/i/g' -e 's/^52$/j/g' -e 's/^53$/k/g' -e 's/^54$/l/g' -e 's/^55$/m/g' -e 's/^56$/n/g' \
    -e 's/^57$/o/g' -e 's/^48$/p/g' -e 's/^49$/q/g' -e 's/^4a$/r/g' -e 's/^4b$/s/g' -e 's/^4c$/t/g' -e 's/^4d$/u/g' -e 's/^4e$/v/g' \
    -e 's/^4f$/w/g' -e 's/^40$/x/g' -e 's/^41$/y/g' -e 's/^42$/z/g' -e 's/^08$/0/g' -e 's/^09$/1/g' -e 's/^0a$/2/g' -e 's/^0b$/3/g' \
    -e 's/^0c$/4/g' -e 's/^0d$/5/g' -e 's/^0e$/6/g' -e 's/^0f$/7/g' -e 's/^00$/8/g' -e 's/^01$/9/g' -e 's/^15$/-/g' -e 's/^16$/./g' \
    -e 's/^67$/_/g' -e 's/^46$/~/g' -e 's/^02$/:/g' -e 's/^17$/\//g' -e 's/^07$/?/g' -e 's/^1b$/#/g' -e 's/^63$/\[/g' -e 's/^65$/\]/g' \
    -e 's/^78$/@/g' -e 's/^19$/!/g' -e 's/^1c$/$/g' -e 's/^1e$/&/g' -e 's/^10$/\(/g' -e 's/^11$/\)/g' -e 's/^12$/*/g' -e 's/^13$/+/g' \
    -e 's/^14$/,/g' -e 's/^03$/;/g' -e 's/^05$/=/g' -e 's/^1d$/%/g' | tr -d '\n' | sed "s/\/clock/\/clock\.json/"
}

extract_provider_link() {
  local provider_id
  case "$1" in
    1) provider_id=$(decrypt_provider_id "wixmp" "/Default :/p" "$2") ;;
    2) provider_id=$(decrypt_provider_id "youtube" "/Yt-mp4 :/p" "$2") ;;
    3) provider_id=$(decrypt_provider_id "sharepoint" "/S-mp4 :/p" "$2") ;;
    *) return 0 ;;
  esac

  if [[ -n "${provider_id}" ]]; then
    local response=$(curl -e "${API_REFERER}" -s "https://${API_BASE}${provider_id}" -A "${USER_AGENT}")
    local episode_link=$(printf '%s' "${response}" | sed 's|},{|\n|g' | sed -nE 's|.*link":"([^"]*)".*"resolutionStr":"([^"]*)".*|\2 >\1|p;s|.*hls","url":"([^"]*)".*"hardsub_lang":"en-US".*|\1|p')

    case "${episode_link}" in
      *repackager.wixmp.com*)
        local extract_link=$(printf "%s" "${episode_link}" | awk -F'>' '{print $2}' | sed 's|repackager.wixmp.com/||g;s|\.urlset.*||g')
        printf "%s" "${episode_link}" | sed -nE 's|.*/,([^/]*),/mp4.*|\1|p' | tr ',' '\n' | while read -r j; do
            printf "%s >%s\n" "${j}" "${extract_link}" | sed "s|,[^/]*|${j}|g"
        done | sort -nr
        ;;
      *master.m3u8*)
        local m3u8_refr=$(printf '%s' "${response}" | sed -nE 's|.*Referer":"([^"]*)".*|\1|p')
        printf 'm3u8_refr >%s\n' "${m3u8_refr}" >"${CACHE_DIR}/m3u8_refr"
        local extract_link=$(printf "%s\n" "${episode_link}" | sed -n '1p' | awk -F'>' '{print $2}')
        local relative_link="${extract_link%/*}"
        local m3u8_streams=$(curl -e "${m3u8_refr}" -s "${extract_link}" -A "${USER_AGENT}")

        if [[ "${m3u8_streams}" == *EXTM3U* ]]; then
          printf "%s\n" "${m3u8_streams}" | awk -v rel="${relative_link}" '/^#EXT-X-STREAM/ { sub(/.*x/, "", $0); sub(/,.*/, "", $0); res=$0; getline; if ($0 !~ /EXT-X-I-FRAME/) print res " >cc>" rel "/" $0 }' | sort -nr
        fi
        ;;
      *) [[ -n "${episode_link}" ]] && printf "%s\n" "${episode_link}" ;;
    esac

    [[ "${provider_id}" == *tools.fast4speed.rsvp* ]] && printf "Yt >%s\n" "${provider_id}"
  fi
}

# ==============================================================================
# PLAYBACK & DOWNLOAD CORE
# ==============================================================================

execute_download() {
  local stream_url="$1"
  local filename="$2"
  local referer="$3"

  if [[ "${stream_url}" == *m3u8* ]]; then
    ffmpeg -extension_picky 0 -referer "${referer}" -loglevel error -stats -i "${stream_url}" -c copy "${DOWNLOAD_DIR}/${filename}.mp4"
  else
    aria2c --referer="${API_REFERER}" --enable-rpc=false --check-certificate=false --continue --summary-interval=0 -x 16 -s 16 "${stream_url}" --dir="${DOWNLOAD_DIR}" -o "${filename}.mp4" --download-result=hide
  fi
}

start_playback() {
  if [[ -z "${TARGET_EPISODE_URL}" ]]; then die "Target episode URL is null."; fi

  if [[ "${DOWNLOAD_MODE}" -eq 1 ]]; then
    execute_download "${TARGET_EPISODE_URL}" "${CLEAN_TITLE} Episode ${SELECTED_EP_NO}" "${GLOBAL_REFERER}"
    return 0
  fi

  # Pure foreground playback. Terminal will wait until mpv is closed.
  mpv --force-media-title="${CLEAN_TITLE} Episode ${SELECTED_EP_NO}" ${REFR_FLAG} "${TARGET_EPISODE_URL}"
}

# ==============================================================================
# MAIN LOGIC
# ==============================================================================

main() {
  DOWNLOAD_MODE=0
  if [[ "$1" == "-d" || "$1" == "--download" ]]; then
    DOWNLOAD_MODE=1
  fi

  printf "\33[2K\r\033[1;34mSystem Check...\033[0m\n"
  check_dependencies "fzf"

  if [[ "${DOWNLOAD_MODE}" -eq 1 ]]; then
    check_dependencies "aria2c" "ffmpeg"
  else
    check_dependencies "mpv"
  fi

  local search_query=""
  while [[ -z "${search_query}" ]]; do
    printf "\33[2K\r\033[1;36mSearch anime: \033[0m"
    read -r search_query
  done

  search_query=$(printf "%s" "${search_query}" | sed "s| |+|g")
  local anime_list=$(fetch_anime_search_results "${search_query}")
  [[ -z "${anime_list}" ]] && die "No results found."

  local selected_anime_data=$(printf "%s\n" "${anime_list}" | awk '{printf "%3d\t%s\n", NR, $0}' | select_menu_item "Select anime: ")
  [[ -z "${selected_anime_data}" ]] && exit 1

  local raw_title=$(printf "%s\n" "${selected_anime_data}" | awk -F'\t' '{print $2}')
  CLEAN_TITLE=$(printf "%s" "${raw_title}" | awk -F'(' '{print $1}' | tr -d '[:punct:]' | sed 's/[[:space:]]*$//')

  local target_id=$(printf "%s\n" "${selected_anime_data}" | awk '{print $1}')
  local ep_list=$(fetch_episode_list "${target_id}")

  SELECTED_EP_NO=$(printf "%s\n" "${ep_list}" | select_menu_item "Select episode: ")
  [[ -z "${SELECTED_EP_NO}" ]] && exit 1

  CACHE_DIR=$(mktemp -d)
  local episode_embed_gql='query ($showId: String!, $translationType: VaildTranslationTypeEnumType!, $episodeString: String!) { episode( showId: $showId translationType: $translationType episodeString: $episodeString ) { episodeString sourceUrls }}'

  local embed_response=$(
    curl -e "${API_REFERER}" -s -G "${API_URL}/api" \
      --data-urlencode "variables={\"showId\":\"${target_id}\",\"translationType\":\"${DEFAULT_MODE}\",\"episodeString\":\"${SELECTED_EP_NO}\"}" \
      --data-urlencode "query=${episode_embed_gql}" \
      -A "${USER_AGENT}" \
      | tr '{}' '\n' | sed 's|\\u002F|\/|g;s|\\||g' | sed -nE 's|.*sourceUrl":"--([^"]*)".*sourceName":"([^"]*)".*|\2 :\1|p'
  )

  # Fetch links from providers
  for provider_idx in 1 2 3; do
    extract_provider_link "${provider_idx}" "${embed_response}" >"${CACHE_DIR}/${provider_idx}" &
  done
  wait

  local scraped_links=$(cat "${CACHE_DIR}"/* | sort -gr -s)
  rm -rf "${CACHE_DIR}"

  local top_stream=$(printf "%s\n" "${scraped_links}" | sed -n '1p')

  if [[ -z "${top_stream}" ]]; then
    if [[ "${ep_list}" == *"${SELECTED_EP_NO}"* ]]; then
      die "Episode is released, but no valid streaming sources were found!"
    else
      die "Episode has not been released yet!"
    fi
  fi

  REFR_FLAG=""
  GLOBAL_REFERER=""

  if [[ "${top_stream}" == *"cc>"* ]]; then
    local extracted_referer=$(printf '%s\n' "${scraped_links}" | sed -nE 's|m3u8_refr >(.*)|\1|p')
    if [[ -n "${extracted_referer}" ]]; then
      REFR_FLAG="--referrer=${extracted_referer}"
      GLOBAL_REFERER="${extracted_referer}"
    fi
  elif [[ "${top_stream}" == *tools.fast4speed.rsvp* ]]; then
    REFR_FLAG="--referrer=${API_REFERER}"
    GLOBAL_REFERER="${API_REFERER}"
  fi

  TARGET_EPISODE_URL="${top_stream#*>}"

  tput cuu1 && tput el
  tput sc

  while true; do
    tput clear
    printf "\33[2K\r\033[1;34mPlaying episode %s...\033[0m\n" "${SELECTED_EP_NO}"

    start_playback

    if [[ "${DOWNLOAD_MODE}" -eq 1 ]]; then
      exit 0
    fi

    tput rc && tput ed

    local next_action=$(printf "next\nreplay\nprevious\nselect\nquit" | select_menu_item "Playing episode ${SELECTED_EP_NO} of ${raw_title}... ")

    case "${next_action}" in
      next)     SELECTED_EP_NO=$(printf "%s\n" "${ep_list}" | awk -v e="${SELECTED_EP_NO}" '$1==e {getline; print}') ;;
      replay)   ;;
      previous) SELECTED_EP_NO=$(printf "%s\n" "${ep_list}" | awk -v e="${SELECTED_EP_NO}" '$1==e {print prev} {prev=$0}') ;;
      select)   SELECTED_EP_NO=$(printf "%s\n" "${ep_list}" | select_menu_item "Select episode: ") ;;
      *)        exit 0 ;;
    esac

    [[ -z "${SELECTED_EP_NO}" ]] && die "Out of range."
  done
}

main "$@"
