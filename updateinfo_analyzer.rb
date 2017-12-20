require 'rexml/document'

updateinfo_path = ARGV[0]
updateinfo_path ||= 'updateinfo.xml'
if !FileTest.exist?(updateinfo_path)
    puts 'updateinfo file not found.'
    exit
end

doc = REXML::Document.new(open(updateinfo_path))

##################################################################################
def somePathCount(doc, path)
    hs = Hash.new()
    someCount = 0
    doc.elements.each(path) do | some |
        someCount += 1
    end
    puts "-------------------------------------------------------------------------------"
    puts path + " count " + someCount.to_s
end

##################################################################################
def somePathDuplicate(doc, path)
    hs = Hash.new()
    doc.elements.each(path) do | someElement |
        hs[someElement.text] ||= 0
        hs[someElement.text] += 1
    end
    isOK = true
    hs.keys.each do | key |
        if hs[key] > 1
            puts "NG! " + path + " is dupulicate [" + key + "] " + hs[key].to_s
            isOK = false
        end
    end
    if isOK
        puts "OK! no duplicate " + path + "."
    end
end

##################################################################################
def grepPathValue(doc, path, isDistinct)
    hs = Hash.new()
    pathCount = 0
    pathValues = ""
    doc.elements.each(path) do | someElement |
        pathCount += 1
        hashKey = someElement.text.to_s
        if !isDistinct
            pathValues += hashKey + "\n"
        else
            hs[hashKey] ||= 0
            hs[hashKey] += 1
        end
    end
    puts "-------------------------------------------------------------------------------"
    puts "grep " + path + " " + pathCount.to_s
    if isDistinct
        hs.keys.each do | key |
            puts key + " " + hs[key].to_s
        end
    else
        puts pathValues
    end
end

##################################################################################
def grepPathAttribute(doc, path, attrName, isDistinct)
    hs = Hash.new()
    pathCount = 0
    pathValues = ""
    doc.elements.each(path) do | someElement |
        pathCount += 1
        hashKey = someElement.attributes[attrName].to_s
        if !isDistinct
            pathValues += hashKey + "\n"
        else
            hs[hashKey] ||= 0
            hs[hashKey] += 1
        end
    end
    puts "-------------------------------------------------------------------------------"
    puts "grep " + path  + "[" + attrName + "] " + pathCount.to_s
    if isDistinct
        hs.keys.each do | key |
            puts key + " " + hs[key].to_s
        end
    else
        puts pathValues
    end
end

##################################################################################
path = "updates/update/id"
grepPathValue(doc, path, true)

path = "updates/update/severity"
grepPathValue(doc, path, true)

path = "updates/update/pkglist/collection/package/filename"
grepPathValue(doc, path, true)

path = "updates/update"
attrName = "type"
grepPathAttribute(doc, path, attrName, true)

path = "updates/update/issued"
attrName = "date"
grepPathAttribute(doc, path, attrName, true)

path = "updates/update/pkglist/collection/package"
attrName = "arch"
grepPathAttribute(doc, path, attrName, true)