module OrganizationHelper
  def app_name
    organization_name.presence || "OpenCamp"
  end

  def organization_name
    Metadata.get("organization_name")
  end
end
