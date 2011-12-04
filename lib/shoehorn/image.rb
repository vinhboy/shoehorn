module Shoehorn
  class Image
     attr_accessor :imgurl, :index
     
     def initialize(imgurl, index)
       @imgurl = imgurl
       @index = index
     end
     
  end
end