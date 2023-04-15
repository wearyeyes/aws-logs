#!/bin/bash

log_group_name=$1
log_stream_name=$2
limit=${3:-10}

aws_profile=${4:-default}
aws_region=${5:-us-east-1}

function describe_log_stream {
  aws logs describe-log-streams \
    --log-group-name "$1" \
    --log-stream-name-prefix "$2" \
    --profile "$3"  \
    --region "$4"
}

function get_last_log_events {
  aws logs get-log-events \
    --log-group-name "$1" \
    --log-stream-name "$2" \
    --limit "$3" \
    --end-time "$4" \
    --profile "$5"  \
    --region "$6"
}

# Describe specific log stream.
log_stream=$(describe_log_stream ${log_group_name} ${log_stream_name} ${aws_profile} ${aws_region})

# Parse the timestamp of the last log event from the log stream description.
last_event_timestamp=$(echo "${log_stream}" | jq .logStreams[0].lastEventTimestamp)

# Printing last log events for specific log stream based on the timestamp of the last log event.
# The timestamp of the last log event is incremented by 1 millisecond to include log events with that timestamp.
echo "$(get_last_log_events ${log_group_name} ${log_stream_name} ${limit} $((last_event_timestamp+1)) ${aws_profile} ${aws_region})"
