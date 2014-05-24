module Maestrano
  module SSO
    class << self
      attr_accessor :http_session, :after_signin_path
    end
    
    # HTTP Session accessor
    # If no http_session then try to get it
    # from rack session
    def self.http_session
      unless self.http_session
        @http_session = env["rack.session"] if (env && env["rack.session"])
      end
      
      return @http_session
    end
    
    # Where to redirect user after signin
    def self.after_signin_path
      if self.http_session && self.http_session['mno_previous_url']
        return self.http_session['mno_previous_url']
      end
      return @after_signin_path
    end
    
    # Build a new SAML Request
    def self.build_request(get_params = {})
      Maestrano::Saml::Request.new(get_params)
    end
    
    # Build a new SAML response
    def self.build_response(saml_post_param)
      Maestrano::Saml::Response.new(saml_post_param)
    end
    
    def self.enabled?
      !!Maestrano.param('sso_enabled')
    end
    
    def self.init_url
      host = Maestrano.param('app_host')
      path = Maestrano.param('sso_app_init_path')
      return "#{host}#{path}"
    end
    
    def self.consume_url
      host = Maestrano.param('app_host')
      path = Maestrano.param('sso_app_consume_path')
      return "#{host}#{path}"
    end
    
    def self.logout_url
      host = Maestrano.param('api_host')
      path = '/app_logout'
      return "#{host}#{path}"
    end
    
    def self.unauthorized_url
      host = Maestrano.param('api_host')
      path = '/app_access_unauthorized'
      return "#{host}#{path}";
    end
    
    def self.idp_url
      host = Maestrano.param('api_host')
      api_base = Maestrano.param('api_base')
      endpoint = 'auth/saml'
      return "#{host}#{api_base}#{endpoint}"
    end
    
    def self.session_check_url(user_uid,sso_session) 
      host = Maestrano.param('api_host')
      api_base = Maestrano.param('api_base')
      endpoint = 'auth/saml'
      return URI.escape("#{host}#{api_base}#{endpoint}/#{user_uid}?session=#{sso_session}")
    end
  end
end