require 'emojidex-vectors'
require 'emojidex_converter'
require 'emojidex/data/utf'
require 'emojidex/data/extended'
require 'emojidex/data/categories'

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
  #   categorized: put emoji in categorized folders
  #   code_type: can be
  #     :en (standard English codes)
  #     :ja (Japanese codes)
  #     :char (raw character codes)
  #     :moji (moji code (:char with Japanese category directories))
  #     :unicode (unicode codes as file names)
  def generate(path = './', size = 64, utf_only = false, code_type = :en, categorized = true, clean_cache = true)
    cache_dir = File.join(path, '.cache')
    @utf.cache(cache_path: cache_dir, formats: [:svg])
    @extended.cache(cache_path: cache_dir, formats: [:svg]) unless utf_only
    collection = Emojidex::Data::Collection.new(local_load_path: "#{cache_dir}/emoji")
    if categorized
      _generate_categories(collection, path, size, code_type)
    else
      _generate_consolidated(collection, path, size, code_type)
    end
    FileUtils.rm_rf(cache_dir) if clean_cache
  end

  private

  def _generate_categories(collection, path, size, code_type)
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

  def _generate_consolidated(collection, path, size, code_type)
     puts "Processing Consolidated Collection"
     puts "Collection emoji Count: #{collection.emoji.count}"
     _write_emoji(path, collection, size, code_type)
  end

  def set_path(path, code_type, category)
    cat_path = ''
    if code_type == :ja || code_type == :moji
      cat_path = File.join(path, category.ja)
    elsif code_type == :en || code_type == :char || :unicode
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
      when :ja then FileUtils.cp "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.code_ja}.png"
      when :moji
        if emoji.moji.nil? || emoji.moji == ""
          FileUtils.cp "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.code}.png"
        else
          FileUtils.cp "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.moji}.png"
        end
      when :en then FileUtils.cp "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.code}.png"
      when :char
        if emoji.moji.nil? || emoji.moji == ""
          FileUtils.cp "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.code}.png"
        else
          FileUtils.cp "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.moji}.png"
        end
      when :unicode
        puts "Transfering #{emoji.code} to unicode #{emoji.unicode}"
        if emoji.unicode.nil? || emoji.unicode == ""
          FileUtils.cp "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.code}.png"
        else
          FileUtils.cp "#{path}/working/#{emoji.code}.png", "#{path}/#{emoji.unicode.to_s}.png"
        end
      end
    end
    FileUtils.rm_rf "#{path}/working/"
  end
end
