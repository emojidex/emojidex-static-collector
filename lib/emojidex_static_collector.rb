require 'emojidex-vectors'
require 'emojidex_converter'
require 'emojidex/data/categories'
require 'emojidex/data/utf'
require 'emojidex/data/extended'

require 'fileutils'

# Generates static collections of emojidex assets
class EmojidexStaticCollector
  def initialize
    @utf = Emojidex::Data::UTF.new
    @extended = Emojidex::Data::Extended.new
    @categories = Emojidex::Data::Categories.new
  end

  # Generates a static collection
  # Args:
  #   path: path to export to
  #   size: export size
  #   utf_only: weather or not to limit to unicode standard emoji
  #   code_type: can be
  #     :en (standard English codes)
  #     :ja (Japanese codes)
  #     :char (raw character codes)
  #     :moji (moji code (:char with Japanese category directories))
  def generate(path = './', size = 64, utf_only = false, code_type = :en, clean_cache = true)
    cache_dir = File.join(path, '.cache')
    @utf.cache!(cache_path: cache_dir, formats: [:svg])
    @extended.cache!(cache_path: cache_dir, formats: [:svg]) unless utf_only
    collection = Emojidex::Data::Collection.new(local_load_path: "#{cache_dir}/emoji")
    _generate_categories(collection, path, size, utf_only, code_type)
    FileUtils.rm_rf(cache_dir) if clean_cache
  end

  private

  def _generate_categories(collection, path, size, _utf_only, code_type)
    @categories.categories.each_value do |category|
      cat_path = set_path(path, code_type, category)
      FileUtils.mkdir_p cat_path

      puts "Processing Category: #{category.code}"
      cat_collection = collection.category(category.code.to_sym)
      puts "Category emoji Count: #{cat_collection.emoji.count}"
      cat_collection.source_path = collection.source_path
      _write_emoji(cat_path, cat_collection, size, code_type)
    end
  end

  def set_path(path, code_type, category)
    cat_path = ''
    if code_type == :ja || code_type == :moji
      cat_path = File.join(path, category.ja)
    elsif code_type == :en || code_type == :char
      cat_path = File.join(path, category.en)
    end
    cat_path
  end

  def _write_emoji(path, collection, size, code_type)
    converter = Emojidex::Converter.new(sizes: { working: size }, destination: path,
                                        noisy: true)
    converter.rasterize_collection collection

    _rename_files(path, collection, code_type)
  end

  def _rename_files(path, collection, code_type)
    collection.each do |emoji|
      case code_type
      when :ja then FileUtils.mv "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.code_ja}.png"
      when :moji then FileUtils.mv "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.moji}.png"
      when :en then FileUtils.mv "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.code}.png"
      when :char then FileUtils.mv "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.moji}.png"
      end
    end
    FileUtils.rm_rf "#{path}/working/"
  end
end
