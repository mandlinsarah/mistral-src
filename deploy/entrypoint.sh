#!/bin/bash

function clean_token() {
    local raw_token="$1"
    echo "${raw_token//[^a-zA-Z0-9]/}" # Removing characters that are not alphanumeric
}

if [[ ! -z "${HF_TOKEN}" ]]; then
    safe_token=$(clean_token "${HF_TOKEN}")
    echo "The HF_TOKEN environment variable is set, logging to Hugging Face with sanitized token."
    python3 -c "import huggingface_hub; huggingface_hub.login('${safe_token}')"
else
    echo "The HF_TOKEN environment variable is not set or empty, not logging to Hugging Face."
fi

# Run the provided command
exec python3 -u -m vllm.entrypoints.openai.api_server "$@"

