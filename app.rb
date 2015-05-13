require 'sinatra'
require 'json'
require_relative 'znc_config'

configure { set :server, :puma }

get '/*' do
  redirect to('https://kiwiirc.com/client?settings=301a91fd4e7cc2f75afd7c246de9dd41')
end

post '/request' do
  @znc_config = ZncConfig.new('../.znc/configs/znc-web-access.conf')

  response = {
    'server' => 'bnc.snoonet.org',
    'port' => 5457,
    'ssl' => true
  }

  unless params.key?('user') && params.key?('password')
    response['error'] = 'Missing parameter'
    return JSON.generate(response)
  end

  unless @znc_config.user_exists(params['user'].downcase)
    response['error'] = 'User not found'
    return JSON.generate(response)
  end

  if !@znc_config.auth_user(params['user'].downcase, params['password'])
    response['error'] = 'Invalid login'
  else
    response['username'] = params['user'].downcase
    response['password'] = params['user'] + '/Snoonet:' + params['password']
  end

  return JSON.generate(response)
end
