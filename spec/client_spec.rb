require 'spec_helper'

RSpec.describe Bamboo::Client do

  let(:subject) { described_class.new 'http://localhost:8090' }
  let(:invalid_response_error) { Bamboo::Client::InvalidResponseError }

  describe '#get_service' do
    it 'gets application' do
      stub_request(:get, 'http://localhost:8090/api/state').
          to_return(status: 200,
                    body: { Services: { '/app/web' => { Id: '/app/web', Acl: 'hdr(host)'} } }.to_json)

      app = subject.get_service('/app/web')
      expect(app).to eq('Id' => '/app/web', 'Acl' => 'hdr(host)')
    end

    it 'does not raise exception when service is not found' do
      stub_request(:get, 'http://localhost:8090/api/state').
          to_return(status: 200, body: { Services: {} }.to_json)

      expect(subject.get_service('/some-id')).to be_nil
    end
  end

  describe '#create_service' do
    it 'creates service' do
      stub_request(:post, 'http://localhost:8090/api/services').
          with(:body => '{"Id":"some-id","Acl":""}').
          to_return(status: 200, body: '{"Id":"some-id","Acl":""}')
      app = subject.create_service('some-id', Acl: '')
      expect(app).to match('Id' => 'some-id', 'Acl' => '')
    end

    it 'raises exception on error' do
      stub_request(:post, 'http://localhost:8090/api/services').
          to_return(status: 400, body: 'Marathon ID might already exist')
      expect { subject.create_service('some-id', {}) }.
          to raise_error(invalid_response_error)
    end
  end

  describe '#delete_service' do
    it 'deletes the service' do
      stub_request(:delete, 'http://localhost:8090/api/services/%252Fapps%252Fsome-id').
          to_return(status: 200, body: 'null')

      expect(subject.delete_service('/apps/some-id')).to eq(true)
    end

    it 'raises exception on error' do
      stub_request(:delete, 'http://localhost:8090/api/services/some-id').
          to_return(status: 400, body: 'zk: node does not exist')

      expect{ subject.delete_service('some-id') }.
          to raise_error(invalid_response_error)
    end
  end

  describe '#update_service' do
    it 'updates the service' do
      stub_request(:put, 'http://localhost:8090/api/services/some-id').
          with(:body => '{"Id":"some-id","Acl":"potato"}').
          to_return(status: 200, body: '{"Id": "some-id", "Acl":"potato"}')

      expect(subject.update_service('some-id', Acl: 'potato')).
          to match('Id' => 'some-id', 'Acl' => 'potato')
    end

    it 'raises exception on error' do
      stub_request(:put, 'http://localhost:8090/api/services/some-id').
          to_return(status: 400, body: 'zk: node does not exist')

      expect{ subject.update_service('some-id', Acl: 'bar') }.
          to raise_error(invalid_response_error)
    end
  end
end
