build:
	docker build -t lovely-kitten-pictures .

run: build
	docker run -p 8084:80 -t -d lovely-kitten-pictures