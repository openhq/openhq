class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: ENV['DEFAULT_FROM_EMAIL']
  layout 'mailer'

  private

  # Applies the correct subdomain if on a multisite install
  def mailer_url_params(opts)
    return opts unless multisite_install?

    opts.merge(subdomain: @team.subdomain)
  end
  helper_method :mailer_url_params

  def multisite_install?
    Rails.application.config.multisite
  end
  helper_method :multisite_install?
end
