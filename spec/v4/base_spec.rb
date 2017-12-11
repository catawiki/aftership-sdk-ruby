require 'spec_helper'

describe AfterShip::V4::Base do
  subject(:instance) { described_class.new(http_verb_method, end_point, query, body) }
  subject(:client) { HTTPClient.new }

  before do
    allow(HTTPClient).to receive(:new).and_return(client)
  end

  let(:http_verb_method) { :get }
  let(:end_point) { 'endpoint' }
  let(:query) { {} }
  let(:body) { {} }

  describe '#call' do
    subject { instance.call }

    context 'when the response returns an invalid json' do
      let(:response) { OpenStruct.new(body: 'test', headers: { 'CF-RAY' => cf_ray }) }
      let(:cf_ray) { 'cf ray' }
      let(:json_response) do
        {
          meta: {
            code: 500,
            message: "Something went wrong on AfterShip's end.",
            type: 'InternalError'
          },
          data: {
            body: 'test',
            cf_ray: cf_ray
          }
        }
      end

      before do
        allow(client).to receive_message_chain(:send).and_return(response)
      end

      it { is_expected.to eq(json_response) }
    end
  end
end
