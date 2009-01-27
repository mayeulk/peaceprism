# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  
  # Method translate edf file in yaml format
  def edf_to_yaml(folder, filename)
    require('yaml')
    f1=File.open(folder+filename+".edf","r")
    f2=File.open(folder+filename+".yml","w")
    first_variable=false
  
    f1.each do |line|
      if first_variable == false
        if line =~ /variable = "/ 
          f2.write("variables:\n")
          first_variable = true
        end
      end
      line=line.gsub("[", '# ').gsub("]",'').gsub(' =',':')
      line=line.gsub(/variable: "(.*),(.*),(.*),(.*),(.*)"/, ' - [\1, \2, \3, \4, \5]')
      line=line.gsub(/"/,"") unless line =~ /data\_set\_citation/
      f2.write(line)
    end
    f1.close
    f2.close
    f2=File.open(folder+filename+".yml","r")
    edf_data=YAML.load(f2)
    return edf_data
  end
  
  

  
  
  
end