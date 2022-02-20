curl -X POST https://api.github.com/repos/cats-team/AdRule/dispatches \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GITHUBTOKEN" \
    --data '{"event_type": "Manual-Update"}'
echo Pass
