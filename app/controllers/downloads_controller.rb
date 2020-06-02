class DownloadsController < ApplicationController
  def index
  end

  def download
    download_file_name = "public/file/shiwake.slp"
    send_file download_file_name
  end
end
