module Atrium
  class Institution
    extend ::Atrium::Paginate
    include ::ActiveAttr::Model

    attribute :code
    attribute :name
    attribute :url
    attribute :small_logo_url
    attribute :medium_logo_url

    # @todo Normalize params interface across gem, most of gem favors hash
    def self.credentials(institution_code)
      endpoint = "/institutions/#{institution_code}/credentials"
      response = ::Atrium.client.make_request(:get, endpoint)

      response["credentials"].map do |credential|
        ::Atrium::Credential.new(credential)
      end
    end

    def self.read(institution_code:)
      endpoint = "/institutions/#{institution_code}"
      response = ::Atrium.client.make_request(:get, endpoint)

      institution_params = response["institution"]
      ::Atrium::Institution.new(institution_params)
    end

    def self.list(query_params: nil, limit: nil)
      paginate_endpoint(:query_params => query_params, :limit => limit)
    end

    def self.list_in_batches(query_params: nil, limit: nil, &block)
      paginate_endpoint_in_batches(:query_params => query_params, :limit => limit, &block)
    end
  end
end
