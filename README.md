# workflows
reusing aciton for wikifactory all repo
## ⚠️ should not include any project core code or key, any secrets should be passed in by github action inputs

## action instruction

folder:
- check_ghcr_tag_existed:
    description:
        use for checking package tag if is existed, and expose `${{ env.TAG_EXISTED }}` let you know tag is existed
        `${{ env.TAG_EXISTED }}` value is string 'true' and 'false'
    inputs:
        user: the github user which one commit the code
        token: github token, needs include permission for checking ghcr tag
        org: organization
        package: github package name
        tag: github package's tag
- pr_branch_name
    description:
        if we have branch name: CU-test-Whatever, and action will change to cu-test-whatever

- pr_commit_sha
    description:
        to get latest commit's hash, will expose `${{ env.last_one_commit_sha }}` for you

- setup_docker
    description:
        will login ghcr and setup semulator that you can add platform like arm64 or amd64 and so on
    args:
        username: github user
        password: token for login ghcr
        registry: the github package which one you want to push or pull image

- setup_oss
    description:
        setup alibaba oss environment
    args:
        id: OSS id
        key: OSS key
        enpoint: oss enpoint
        config_dir: the oss config folder you want to place in

- slack_action
    description:
        setup slack and send the message
    args:
        pr_message_as_content: boolean, if given true, then action will pull the pr message as content, and arg `message` will be invalid
        token: github token for reading pr message
        message: custom message, if use message, then you should not use arg `pr_message_as_content`, they're conflict
        title: slack message title
        repo: using in footer to access repo when u click it
        webhook_url: slack webhook url