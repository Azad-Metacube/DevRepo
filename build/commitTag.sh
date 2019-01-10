
PLANKEY=$1
REVISION=$2
PLANNAME=$3
BUILDNUMBER=$4
REPOSITORYURL=$5
BITBUCKETPASSWORD=$6
 
if [[ -z "${BITBUCKETPASSWORD// }" ]]
then
    BITBUCKETPASSWORD=${bamboo_bitbucket_password}
fi
 
echo creating tag for commit: $REVISION
DATE=`date '+%Y%m%d%H%M%S'`
TAGNAME="$PLANKEY-$DATE"
echo final tag name: $TAGNAME
 
echo creating repo to create and push tag
ACTUALURL=$REPOSITORYURL
USERNAME="kavitabeniwal"
PASSWORD=$BITBUCKETPASSWORD
REPOURL=${ACTUALURL#*https://}
REPOURL="https://"$USERNAME:$PASSWORD@$REPOURL
git remote add central2 $REPOURL
git config --global user.email "kavita.beniwal@metacube.com"
git config --global user.name $USERNAME
git config --global push.default simple
 
echo deleting previous tags
if [[ ! -z "${PLANKEY// }" ]]
then
    echo finding if there is a tag
    echo tags: `git tag -l --sort=v:refname $PLANKEY* | head -n -1`
    TEMP=`git tag -l --sort=v:refname $PLANKEY* | head -n -1`
	echo tag found: $TEMP
    printf "\n"
    if [[ ! -z "${TEMP// }" ]]
    then
    for tag in `git tag -l --sort=v:refname $PLANKEY* | head -n -1`
        do
            git tag -d $tag
            git push central2 :refs/tags/$tag
        done
    fi
fi
 
echo pushing new tag
git tag $TAGNAME -m "$PLANNAME build number $BUILDNUMBER passed build." $REVISION
git push central2 $TAGNAME
git ls-remote --exit-code --tags central2 $BUILDNUMBER
git remote remove central2