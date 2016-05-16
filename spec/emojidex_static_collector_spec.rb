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
      collector.generate(@tmpdir + '/emojidex', 512)
      expect(File.exist?(@tmpdir + '/emojidex/')).to be_truthy
    end

    it '日本語のコードを使ってコレクションを作成する' do
      expect(collector.generate(@tmpdir + '/日本語', 8, false, :ja)).to be_truthy
      expect(File.exist?(@tmpdir + '/日本語/抽象物/18禁.png')).to be_truthy
      expect(File.exist?(@tmpdir + '/日本語/抽象物/糞.png')).to be_truthy
    end

    it 'generates a collection using moji character codes' do
      expect(collector.generate(@tmpdir + '/moji', 8, true, :moji)).to be_truthy
    end

    it 'generates a collection of UTF only, extended emoji should not be included' do
      collector.generate(@tmpdir + '/UTF_only', 8, true, :en)
      expect(File.exist?(@tmpdir + '/UTF_only/Faces/angry.png')).to be_truthy
      expect(File.exist?(@tmpdir + '/UTF_only/Abstract/shit.png')).to be_falsey
    end

    it 'generates a collection with unicode codes as file names' do
      collector.generate(@tmpdir + '/unicode', 8, false, :unicode)
      expect(File.exist?(@tmpdir + '/unicode/Symbols/00ae.png')).to be_truthy
      expect(File.exist?(@tmpdir + '/unicode/Abstract/shit.png')).to be_truthy
    end

    it 'generates a collection, not sorted into categories, with unicode codes for file names' do
      collector.generate(@tmpdir + '/uncategorized_charcodes', 300, false, :unicode, false)
      expect(File.exist?(@tmpdir + '/uncategorized_charcodes/00ae.png')).to be_truthy
      expect(File.exist?(@tmpdir + '/uncategorized_charcodes/0033-20e3.png')).to be_truthy
      expect(File.exist?(@tmpdir + '/uncategorized_charcodes/shit.png')).to be_truthy
    end
  end
end
