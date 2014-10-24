require 'emojidex_static_collector'

require 'fileutils'

describe EmojidexStaticCollector do
  let(:collector) { EmojidexStaticCollector.new }

  before(:all) do
    @tmpdir = File.expand_path('../../tmp', __FILE__)
    FileUtils.rm_rf @tmpdir if Dir.exist? @tmpdir
    Dir.mkdir @tmpdir
  end

  describe '.generate' do
    it 'generates a collection' do
      # binding.pry
      collector.generate(@tmpdir + '/emojidex', 512)
      expect(File.exist?(@tmpdir + '/emojidex/')).to be_truthy
    end

    it 'generates a collection of UTF only' do
      expect(collector.generate(@tmpdir + '/UTF', 512, false)).to be_truthy
    end

    it '日本語のコードを使ってコレクションを作成する' do
      expect(collector.generate(@tmpdir + '/日本語', 8, true, :ja)).to be_truthy
    end

    it 'generates a collection using moji character codes' do
      expect(collector.generate(@tmpdir + '/moji', 8, true, :moji)).to be_truthy
    end
  end
end
