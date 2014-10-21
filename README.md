== README

I am having an issue where Paperclip is not preventing me from
uploading files that have been saved with an incorrect file extension
(the most basic method of spoofing a media type). In the logs (in
development mode), I see the file command run. And when I run it from
my shell, it gives the correct mime type. But my Rails app ignores
that information and saves the file along with the spoofed file type
provided by my web browser.

Setup: 
       OS: OsX 10.7.5 Darwin Kernel Version 11.4.2
           also works on RHEL 5
       Ruby: MRI ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-darwin11.0] via RVM
       Rails: 4.1.6 (with turbogears removed)
       Paperclip: 4.2.0

I have included the Gemfile.lock, example data, and the sqlite3
database after uploading the file fake.doc. The document and
document_category code was generated by using rails g scaffold with
hand editing to add relationships and paperclip configuration.

The example data is in public/example_files. fake.pdf is the original
pdf document. fake.doc is a copy of the same file with the extension
changed to .doc. `diff` will show them to be identical and `file`
detects both of them as PDF files:

$ file --mime public/example_files/fake.doc public/example_files/fake.pdf
public/example_files/fake.doc: application/pdf; charset=binary
public/example_files/fake.pdf: application/pdf; charset=binary

The development log for uploading fake.doc is as follows. Note that
the browser sends the content type as "application/msword".

Started POST "/documents" for 127.0.0.1 at 2014-10-20 17:53:24 -0700
Processing by DocumentsController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"X5QYqaGTJQ4UaFoOMWgIDlgrl5bzpE6/Ruv73DGu20w=", "document"=>{"file"=>#<ActionDispatch::Http::UploadedFile:0x007fb3f4f9d8c8 @tempfile=#<Tempfile:/var/folders/3n/z3fydthx5dzdpxpv3w0ql3x80000gn/T/RackMultipart20141020-54222-1aqigju>, @original_filename="fake.doc", @content_type="application/msword", @headers="Content-Disposition: form-data; name=\"document[file]\"; filename=\"fake.doc\"\r\nContent-Type: application/msword\r\n">, "document_category_id"=>"1"}, "commit"=>"Create Document"}
Command :: file -b --mime '/var/folders/3n/z3fydthx5dzdpxpv3w0ql3x80000gn/T/144c9defac04969c7bfad8efaa8ea19420141020-54222-ylqr8t.doc'
   (0.2ms)  begin transaction
Command :: file -b --mime '/var/folders/3n/z3fydthx5dzdpxpv3w0ql3x80000gn/T/144c9defac04969c7bfad8efaa8ea19420141020-54222-1yiwcel.doc'
Binary data inserted for `string` type on column `file_content_type`
  SQL (0.7ms)  INSERT INTO "documents" ("created_at", "document_category_id", "file_content_type", "file_file_name", "file_file_size", "file_updated_at", "updated_at") VALUES (?, ?, ?, ?, ?, ?, ?)  [["created_at", "2014-10-21 00:53:24.529199"], ["document_category_id", 1], ["file_content_type", "application/msword"], ["file_file_name", "fake.doc"], ["file_file_size", 638283], ["file_updated_at", "2014-10-21 00:53:24.474680"], ["updated_at", "2014-10-21 00:53:24.529199"]]
   (4.2ms)  commit transaction
Redirected to http://localhost:3000/documents/1

I am unclear why the MediaTypeSpoofDetector# gets run twice. But
repeating the same commands from the shell, both return the correct
mimetype: 'application/pdf'

$ file -b --mime '/var/folders/3n/z3fydthx5dzdpxpv3w0ql3x80000gn/T/144c9defac04969c7bfad8efaa8ea19420141020-54222-1yiwcel.doc'
application/pdf; charset=binary

$ file -b --mime '/var/folders/3n/z3fydthx5dzdpxpv3w0ql3x80000gn/T/144c9defac04969c7bfad8efaa8ea19420141020-54222-ylqr8t.doc'
application/pdf; charset=binary

But Paperclip records the spoofed content type in file_content_type: 

    Filename: fake.doc
    File size: 638283
    URL: /system/documents/000/000/001/fake.doc
    Content Type: application/msword
    Document category: 1