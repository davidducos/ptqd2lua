

query_md5=$1
position=$2

echo "Query template:"
cat template/*${query_md5}*_query

echo "Head of Sessions:"
grep $query_md5 code/*session | cut -d':' -f1 | sort | uniq | head


echo "Head of Data:"
grep $query_md5 code/*session | cut -d':' -f1 | sort | uniq | while read filename ; do cat data/$(basename $filename _session | sed 's/_/\//')/*_data | grep $query_md5 ; done | head 

echo "Data Template:"
grep $query_md5 code/*session | cut -d':' -f1 | sort | uniq | while read filename ; do cat data/$(basename $filename _session | sed 's/_/\//')/*_data | grep $query_md5 ; done | cut -d'"' -f2-|  awk -F'" , "' '{print $2}' | sort | uniq | while read md5template; do cat template/${md5template}_data; echo ; done

echo "Data Example:"
grep $query_md5 code/*session | cut -d':' -f1 | sort | uniq | while read filename ; do cat data/$(basename $filename _session | sed 's/_/\//')/*_data | grep $query_md5 ; done | cut -d'"' -f2-|  awk -F'" , "' '{print $1"\t"$2}' | sort | uniq | while read fornext; do echo "$fornext" | sed 's/\t/\n/g' | lua /home/davidducos/git/ptqd2lua/shorttest.lua | sed 's/%s/\n/g' | while read line;
	do
		if [ "$i" == "" ]
		then
			i=1;
		fi
		echo "$line : $i"
		i=$(( $i + 1 ))
	done
done
if [ "$position" != "" ]
then
	grep $query_md5 code/*session | cut -d':' -f1 | sort | uniq | while read filename ; do echo "data/$(basename $filename _session | sed 's/_/\//g')/$(grep $query_md5 "template/$(basename $filename _session )_session" | cut -f6 -d'"' | cut -f${position} | sort | uniq | sed 's/var/gen/g' | while read grep ; do egrep "$grep" $filename |cut -d'"' -f2-| awk -F'" , "' '{print $1"_"$2"_"}' ; echo -n "$grep" | cut -f3 -d'_' ; echo -ne "_generate" ;done | sed ':a;N;$!ba;s/\n//g'  )" ; done | while read thefile; do echo $thefile; cat $thefile; done 
fi
