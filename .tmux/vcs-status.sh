#!/usr/bin/env bash

#######################################
# BlackEagle's vcs-status for tmux    #
#######################################

if [[ $2 -eq 1 ]]; then
    SCMDIRTY=1

    # front colors
    COLRED='#[fg=#cc342b]'
    COLGRN='#[fg=#198844]'
    COLYLW='#[fg=#fba922]'
    COLBLU='#[fg=#3971ed]'
    COLCYN='#[fg=#39d3ed]'

    # border color
    PSCOL='#[fg=#3971ed]'
else
    SCMDIRTY=0

    # front colors
    COLRED='#[fg=default]'
    COLGRN='#[fg=default]'
    COLYLW='#[fg=default]'
    COLBLU='#[fg=default]'
    COLCYN='#[fg=default]'

    PSCOL='#[fg=default]'
fi

function vcsstatus {
    local vcsfound=0
    if [[ $(id -u) != "0" ]]; then
        if [[ $vcsfound -ne 1 ]] && which git > /dev/null 2>&1; then
            if git rev-parse > /dev/null 2>&1; then
                GITBRANCH=$(git symbolic-ref HEAD 2>/dev/null)
                GITBRANCH=${GITBRANCH/refs\/heads\//}
                GITDIRTY=
                if [[ $SCMDIRTY -eq 1 ]]; then
                    # if has unstaged changes
                    git diff --no-ext-diff --quiet --exit-code || GITDIRTY=" *"
                    # if it has staged changes
                    if [[ "$GITDIRTY" = "" ]]; then
                        git diff --staged --no-ext-diff --quiet --exit-code || GITDIRTY=" +"
                    fi
                fi
                if [[ "${GITBRANCH}" == "master" ]]; then
                    GITBRANCH="${PSCOL}─(${COLYLW}git${PSCOL})─(${COLGRN}${GITBRANCH}${GITDIRTY}${PSCOL})"
                elif [[ "${GITBRANCH}" == "" ]]; then
                    GITBRANCH="${PSCOL}─(${COLYLW}git${PSCOL})─(${COLRED}$(git rev-parse --short HEAD)...${GITDIRTY}${PSCOL})"
                else
                    GITBRANCH="${PSCOL}─(${COLYLW}git${PSCOL})─(${COLCYN}${GITBRANCH}${GITDIRTY}${PSCOL})"
                fi
                printf "${GITBRANCH}"
                vcsfound=1
            fi
        fi
        if [[ $vcsfound -ne 1 ]] && which hg > /dev/null 2>&1; then
            if hg branch > /dev/null 2>&1; then
                HGBRANCH=$(hg branch 2>/dev/null)
                HGDIRTY=
                if [[ $SCMDIRTY -eq 1 ]]; then
                    [[ "$(hg status -n | wc -l)" == "0" ]] || HGDIRTY=" *"
                fi
                if [[ "${HGBRANCH}" == "default" ]]; then
                    HGBRANCH="${PSCOL}─(${COLYLW}hg${PSCOL})─(${COLGRN}${HGBRANCH}${HGDIRTY}${PSCOL})"
                else
                    HGBRANCH="${PSCOL}─(${COLYLW}hg${PSCOL})─(${COLRED}${HGBRANCH}${HGDIRTY}${PSCOL})"
                fi
                printf "${HGBRANCH}"
                vcsfound=1
            fi
        fi
        if [[ $vcsfound -ne 1 ]] && which svn > /dev/null 2>&1; then
            if svn info > /dev/null 2>&1; then
                SVNREVISION=$(svn info | sed -ne 's/^Revision: //p')
                if [[ $SCMDIRTY -eq 1 ]]; then
                    [[ "$(svn status | wc -l)" == "0" ]] || SVNDIRTY=" *"
                fi
                SVNBRANCH="${PSCOL}─(${COLYLW}svn${PSCOL})─(${COLGRN}${SVNREVISION}${SVNDIRTY}${PSCOL})"
                printf "${SVNBRANCH}"
                vcsfound=1
            fi
        fi
        if [[ $vcsfound -ne 1 ]] && which bzr > /dev/null 2>&1; then
            if bzr nick > /dev/null 2>&1; then
                BZRREVISION=$(bzr revno)
                if [[ $SCMDIRTY -eq 1 ]]; then
                    [[ "$(bzr status | wc -l)" == "0" ]] || BZRDIRTY=" *"
                fi
                BZRBRANCH="${PSCOL}─(${COLYLW}bzr${PSCOL})─(${COLGRN}${BZRREVISION}${BZRDIRTY}${PSCOL})"
                printf "${BZRBRANCH}"
                vcsfound=1
            fi
        fi
    fi
}

(
    cd $1
    vcsstatus
)
