require_relative 'unzip'
require_relative 'compile'
require_relative 'copy_execution_files'

class AutoCheckHomework
  include UnZip
  include Compile
  include CopyExecutionFiles
  include Directory

  # 先生とTAのID
  TEATURES_ID = %w(32115160 52034959 281743160 281843088)

  def self.execute(kadai_dir)
    self.new.execute(kadai_dir)
  end

  def initialize
    super
  end

  def execute(kadai_dir)
    raise "#{kadai_dir}はありません" unless File.directory?(kadai_dir)
    try_exist_dirs
    
    # unzip
    unzip_traverse(kadai_dir)

    # compile
    compile_traverse(kadai_dir)

    # 実行に必要なファイル群を、生成された受講生の実行ディレクトリにコピー
    copy_execution_files

    # 先生とTAはリストから除く
    @not_submitted_list.reject! { |id, _| TEATURES_ID.member?(id) }
    display_data
  end

  private

  def display_data
    puts
    puts "--- 未提出者リスト ---"
    puts @not_submitted_list.map { |item| item.join("\t") }
    puts @not_submitted_list.size

    puts "--- 解凍エラー ---"
    puts @unzip_error_list.map { |item| item.join("\t") }
    puts @unzip_error_list.size

    puts "--- コンパイルエラー ---"
    puts @cannot_compile_list.map { |item| item.join("\t") }
    puts @cannot_compile_list.size
  end
end


if $0 == __FILE__
  AutoCheckHomework.execute(ARGV[0])
end
