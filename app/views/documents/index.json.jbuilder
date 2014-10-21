json.array!(@documents) do |document|
  json.extract! document, :id, :document_category_id
  json.url document_url(document, format: :json)
end
