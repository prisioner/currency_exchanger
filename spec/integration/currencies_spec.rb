require "swagger_helper"

describe "Currencies API" do
  let!(:currencies) do
    [
      Currency.create!(iso: "USD", name: "United States Dollar", rate: 1),
      Currency.create!(iso: "RUB", name: "Russian Ruble", rate: 30),
      Currency.create!(iso: "JPY", name: "Japanese Yen", rate: 50),
      Currency.create!(iso: "CNY", name: "Chinese Yuan", rate: 15),
      Currency.create!(iso: "UAH", name: "Ukrainian Hryvnia", rate: 10)
    ]
  end

  let(:parsed_response) { JSON.parse(response.body, symbolize_names: true) }

  before { stub_const("::AUTH_TOKEN", "currency_exchanger_auth_token") }

  path "/api/v1/currencies" do
    get "return cuirrencies list" do
      parameter name: :Authorization, in: :header, required: true,
        schema: { type: :string }, description: "Bearer TOKEN"
      parameter name: :page, in: :query, required: false,
        schema: { type: :integer }, description: "Page number for pagination"

      response "200", "successful request" do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              iso: { type: :string, description: "Currency ISO code" },
              name: { type: :string, description: "Currency name" },
              rate: { type: :string, description: "Currency rate (USD based)" }
            },
            required: %i[iso name rate]
          }

        let(:Authorization) { "Bearer currency_exchanger_auth_token" }
        let(:expected_response) do
          [
            {iso: "CNY", name: "Chinese Yuan", rate: "15.0"},
            {iso: "JPY", name: "Japanese Yen", rate: "50.0"},
            {iso: "RUB", name: "Russian Ruble", rate: "30.0"},
            {iso: "UAH", name: "Ukrainian Hryvnia", rate: "10.0"},
            {iso: "USD", name: "United States Dollar", rate: "1.0"}
          ]
        end

        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            'application/json' => {
              examples: {
                success_example: {
                  value: parsed_response,
                },
              },
              schema: example.metadata[:response][:schema],
            },
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        run_test! do
          expect(parsed_response).to eq(expected_response)
        end
      end

      response "403", "Auth token invalid" do
        schema type: :object, properties: { error: { type: :string } }

        let(:Authorization) { "Bearer invalid_token" }
        let(:expected_response) do
          {
            error: 'Auth token invalid'
          }
        end

        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            'application/json' => {
              examples: {
                error_example: {
                  value: parsed_response,
                },
              },
              schema: example.metadata[:response][:schema],
            },
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        run_test! do
          expect(parsed_response).to eq(expected_response)
        end
      end
    end
  end

  path "/api/v1/currencies/{iso}" do
    get "return cuirrency details" do
      parameter name: :Authorization, in: :header, required: true,
        schema: { type: :string }, description: "Bearer TOKEN"
      parameter name: :iso, in: :path, required: true,
        schema: { type: :string }, description: "Currency ISO code"

      response "200", "successful request" do
        schema type: :object,
          properties: {
            iso: { type: :string, description: "Currency ISO code" },
            name: { type: :string, description: "Currency name" },
            rate: { type: :string, description: "Currency rate (USD based)" }
          },
          required: %i[iso name rate]

        let(:Authorization) { "Bearer currency_exchanger_auth_token" }
        let(:iso) { "rub" }
        let(:expected_response) do
          {
            iso: "RUB",
            name: "Russian Ruble",
            rate: "30.0"
          }
        end

        after do |example|
          content = example.metadata[:response][:content] || {}
          example_spec = {
            'application/json' => {
              examples: {
                success_example: {
                  value: parsed_response,
                },
              },
              schema: example.metadata[:response][:schema],
            },
          }
          example.metadata[:response][:content] = content.deep_merge(example_spec)
        end

        run_test! do
          expect(parsed_response).to eq(expected_response)
        end
      end
    end
  end
end
