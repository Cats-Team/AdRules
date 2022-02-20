curl -X POST https://api.github.com/repos/hacamer/adblock_list/dispatches \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token $GITHUBTOKEN" \
    --data '{"event_type": "Manual-Update"}'
echo Pass
