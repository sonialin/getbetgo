class AddDocumentableToProofs < ActiveRecord::Migration
  def change
    add_reference :proofs, :documentable, polymorphic: true, index: true
  end
end
