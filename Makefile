run_website:
	docker build -t goviolin-multistage . && \
		docker run -p 5000:5000 -d goviolin-multistage
