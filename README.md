# aws-logs

Bash script to request the latest logs from the AWS CloudWatch log stream.

### The problem
The AWS API has a **GetLogEvents** method for getting logs. By default, it retrieves the latest logs. 
This request works well for log streams that have been filled recently (in my experiments, within the last 24 hours).
However, if you want to use a log stream with log events recorded several days ago, AWS will return an empty list. It is possible to novigate on log stream using 'nextBackwardToken', but the more days have passed, the more steps will need to be taken (with recieving empty lists of events every time!) to reach the last log.

To avoid a large number of requests, you can describe the log stream (the **DescribeLogStreams** method), take the timestamp of the last log event from the description, and then use this value (increased by 1 millisecond) in the **--end-time** argument of the **GetLogEvents** method.

### Prerequisites
- Bash
- AWS CLI v2
- jq (to parse json response)

### How to use

Run the following command to give the executable permission for the script:
```
chmod +x get-last-logs.sh
```

Run the script with following arguments:
```
./get-last-logs.sh <log_group_name> <log_stream_name> [<limit> <aws_profile> <aws_region>]
```
Requered arguments:

- *log_group_name* - the name of the log group
- *log_stream_name* - the name of the log stream in the log group

Optional arguments:
- *limit* - the number of log events to retrieve (10 by default)
- *aws_profile* - your aws profile name ('default' profile by default)
- *aws_region* - the aws region ('us-east-1' by default)
