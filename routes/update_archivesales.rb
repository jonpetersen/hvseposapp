class UpdatearchivesalesController < Sinatra::Base

  get '/' do
    CreateArchivesales.down
    CreateArchivesales.up
    "done"
  end

end