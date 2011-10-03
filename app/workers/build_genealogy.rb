require 'open-uri'

class BuildGenealogy
  @queue = :genealogy_queue

  def self.perform(document_id, force = false)
    document = Document.find(document_id)
    document.links.each do |link|
      reference = Document.first(conditions: { uri: link })
      document.references << reference
    end
    p "#{document.title}: #{document.references.length} references"
  end
end

