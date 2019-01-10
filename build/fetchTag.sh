TAGNAME=$1
LASTCOMMIT=$2
#if there is finding a tag 
if [[ ! -z "${TAGNAME// }" ]]
then
    # git tag -l <pattern>
    TEMP=`git tag -l $TAGNAME*`
    if [[ ! -z "${TEMP// }" ]]
    then
        LASTTAG=`git tag -l --sort=-v:refname $TAGNAME-* | head -1`
        # git show mylabel --pretty=format:"%H" --quiet
        TAGCOMMIT=`git show $LASTTAG --pretty=format:\"%H\" --quiet | tail -n1`
        TAGCOMMIT="${TAGCOMMIT%\"}"
        TAGCOMMIT="${TAGCOMMIT#\"}"
        
    fi
fi

if [[ ! -z "${TAGCOMMIT// }" ]]
then
	echo $TAGCOMMIT $LASTCOMMIT
else
	echo @~..@
fi