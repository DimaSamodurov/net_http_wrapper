RSpec.describe NetHttpWrapper do
  before do
    NetHttpWrapper.after_request_callbacks.clear
    stub_request(:any, 'example.com')
  end

  let(:logger) { double }

  context 'when disabled' do
    before do
      NetHttpWrapper.disable
    end

    it 'does not call after_request callbacks on HTTP request' do
      NetHttpWrapper.after_request { logger.info }

      expect(logger).to_not receive(:info)

      Net::HTTP.get('example.com', '/')
    end
  end

  context 'when enabled' do
    before do
      # When using WebMock, we should enable wrapper after the WebMock initialization.
      # Otherwise WebMock will hide wrapped request.
      NetHttpWrapper.enable
    end

    it 'prepends Net::HTTP::Request with NetHttpWrapper' do
      expect(Net::HTTP.ancestors).to include(NetHttpWrapper)
    end

    it 'calls after_request callbacks' do
      NetHttpWrapper.after_request { logger.info 'timing' }
      NetHttpWrapper.after_request { logger.error 'message' }

      expect(logger).to receive(:info).with('timing')
      expect(logger).to receive(:error).with('message')

      Net::HTTP.get('example.com', '/')
    end
  end

  it 'has a version number' do
    expect(NetHttpWrapper::VERSION).not_to be nil
  end
end
