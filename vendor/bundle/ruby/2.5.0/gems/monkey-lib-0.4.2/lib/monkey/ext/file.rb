module Monkey
  module Ext
    module File
      module ClassMethods
        def write(path, content = '', mode = 'w')
          File.open(path, mode) { |f| f.write content }
          content
        end
      end
    end
  end
end