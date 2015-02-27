module OrganisationHelper
  def app_name
    organisation_name.presence || "OpenCamp"
  end

  def organisation_name
    Metadata.get("organisation_name")
  end
end
