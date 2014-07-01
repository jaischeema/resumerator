# Resumerator

Create resumes from YAML files with style and ease.

## Usage

It is a sinatra app which just reads all the resumes from the `resumes` directory and renders them as them HTML pages.

<pre>
bundle install
ruby main.rb
</pre>

From here on, you can simple save them as `PDF` using your browser or if you are tech-savvy, use `wkhtml2pdf` to convert it to `PDF`.

## Adding new resume

* Create new resume under `resumes` directory.
	* Use one of the existing files to see the correct format and all required attributes.
* Add in the style layout file under `views` directory.
* Add in the theme css file under `public/css` directory.

## License

MIT License
