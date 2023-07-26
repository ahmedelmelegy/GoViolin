run_website:
	docker build -t goviolin-multistage . && \
		docker run --name goviolin -p 5000:5000 -d --rm goviolin-multistage
stop_website:
	docker stop goviolin