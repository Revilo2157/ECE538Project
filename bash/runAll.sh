rm -r outputs/*

./run4paths.sh 10
./run4paths.sh 15

./run4small.sh 1
./run4small.sh 1.1
./run4small.sh 1.2

rm outputs.zip
zip -r outputs.zip outputs

git add .
git commit -m "Refreshed Outputs"
git push

