server "192.168.3.33",
  roles: %w{web db app},
  ssh_options: {
    user: "deploy",
    # keys: %w(/home/user_name/.ssh/id_rsa),
    forward_agent: false,
    auth_methods: %w(publickey password)
    # password: "please use keys"
  }
