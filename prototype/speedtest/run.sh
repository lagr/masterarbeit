
for lang in {go,ruby}
do
	rm ${lang}_results
	touch ${lang}_results
	docker rm -f $(docker ps -a | grep -E "hello_$lang" | awk '{print $1}') > /dev/null

	for j in {1..1000}
	do
		gtime -f "%e" -o ${lang}_results -a docker run --name hello_$lang hello_$lang > /dev/null
		docker rm -f $(docker ps -a | grep -E "hello_$lang" | awk '{print $1}') > /dev/null
	done
done
