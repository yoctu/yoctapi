# Route to set for activation saml
#ROUTE['/acs':'POST':'none']='saml::retrieve::Identity'
#ROUTE['/acs':'GET':'none']='saml::retrieve::Identity'
#ROUTE['/login':'GET':'none']='saml::buildAuthnRequest'
#ROUTE['/':'GET':'connect']="html::print::out ${html_dir}/home.html"

api_command="Api::call::function"
default_api_function="Yoctapi::api::main"

# router="route::api::mode"
# router="route::check"

# Defaults routes
#AUTH['/':'GET']="htpasswd"
#AUTH['/':'POST']="htpasswd"
AUTH['/':'GET']="none"

RIGHTS['/':'GET']="none"
