require 'open-uri'

class BuildGenealogy
  @queue = :genealogy_queue

  def self.perform(document_id, force = false)
    document = Document.find(document_id)
    document.links.each do |link|
      begin
        reference = Document.first(conditions: { uri: link })
        document.references << reference if reference.empty?
      rescue Mongoid::Errors::DocumentNotFound
        # rebuild?
      end
    end
    p "#{document.title}: #{document.references.length} references, #{document.referenced_by.length} referenced_by"
  end
end

