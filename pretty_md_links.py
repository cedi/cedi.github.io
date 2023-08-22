#!/usr/bin/python

import sys
import re
import argparse

'''Read a Markdown file and tidy its links, reflinks, and footnotes.
Inline links will be replaced by reference links. Reference links
and Footnotes will be numbered in the order they appear in the text
and placed at the bottom of the file.'''

# The regex for finding footnotes
footnote = re.compile(r'\[\^(\d+)\][^:|\S]')

# The regex for finding the footnote label
footnoteLabel = re.compile(r'^\[\^([^\]]+)\]:\s+(.+)$', re.MULTILINE)

# The regex for finding reference links in the text. Don't find
# footnotes by mistake.
refLink = re.compile(r'\[([^\]]+)\]\[([^^\]]+)\]')

# The regex for finding the label. Again, don't find footnotes
# by mistake.
linkLabel = re.compile(r'^\[([^^\]]+)\]:\s+(.+)$', re.MULTILINE)

# The regex for finding inline links in the text. Don't find
# footnotes by mistake.
inlineLink = re.compile(r'[^!]\[([^\]]+)\]\(([^^\]]+)\)')

def cleanupInlineLink(text):
    def reflinkReplace(m):
        'Rewrite reference links with the reordered link numbers.'
        return '[%s][%d]' % (m.group(1), order.index(m.group(2)) + firstLabelValue)

    links = inlineLink.findall(text)
    labels = dict(linkLabel.findall(text))

    if len(links) == 0:
        print("- No inline links found to cleanup")
        return text

    firstLabelValue = 1

    if len(labels) != 0:
        firstLabelValue = 1 + sorted([ eval(i) for i in labels.keys() ])[-1]

    # Determine the order of the links in the text. If a link is used
    # more than once, its order is its first position.
    order = []
    for i in links:
        if order.count(i[1]) == 0:
            order.append(i[1])

    # Make a list of the references in order of appearance.
    newlabels = [ '[%d]: %s' % (i + firstLabelValue, j) for (i, j) in enumerate(order) ]

    # put the new ones at the end of the text.
    text += 3*'\n' + '\n'.join(newlabels)

    print("* converted %d in-line links to reflinks" % len(links))

    # Rewrite the links with the new reference numbers.
    return inlineLink.sub(reflinkReplace, text)

def cleanupReflink(text):
    def labelReplace(m):
        'Rewrite reference links with the reordered link numbers.'
        return '[%s][%d]' % (m.group(1), order.index(m.group(2)) + 1) 

    links = refLink.findall(text)
    labels = dict(linkLabel.findall(text))

    if len(links) == 0:
        print("- No reference links found to cleanup")
        return text

    # Determine the order of the links in the text. If a link is used
    # more than once, its order is its first position.
    order = []
    for i in links:
        if order.count(i[1]) == 0:
            order.append(i[1])

    # Make a list of the references in order of appearance.
    newlabels = [ '[%d]: %s' % (i + 1, labels[j]) for (i, j) in enumerate(order) ]

    # Remove the old references and put the new ones at the end of the text.
    text = linkLabel.sub('', text).rstrip() + 3*'\n' + '\n'.join(newlabels)

    print("* removed %d stale reference links" % (len(labels) - len(newlabels)))
    print("* renumbered %d reference links" % len(links))

    # Rewrite the links with the new reference numbers.
    return refLink.sub(labelReplace, text)

def cleanupFootnote(text):
    def footnoteReplace(m):
        'Rewrite footnote with the reordered link numbers.'
        return '[^%d] ' % (order.index(m.group(1)) + 1)
        
    footnotes = footnote.findall(text)
    labels = dict(footnoteLabel.findall(text))

    if len(footnotes) == 0:
        print("- No footnotes found to cleanup")
        return text

    # Determine the order of the footnotes in the text. If a footnote is used
    # more than once, its order is its first position.
    order = []
    for i in footnotes:
        if order.count(i) == 0:
            order.append(i)

    # Make a list of the references in order of appearance.
    newlabels = [ '[^%d]: %s' % (i + 1, labels[j]) for (i, j) in enumerate(order) ]

    # Remove the old references and put the new ones at the end of the text.
    text = footnoteLabel.sub('', text).rstrip() + 3*'\n' + '\n'.join(newlabels)

    print("* removed %d stale footnotes" % (len(labels) - len(newlabels)))
    print("* renumbered %d footnotes" % len(footnotes))


    # Rewrite the links with the new reference numbers.
    return footnote.sub(footnoteReplace, text)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='cleanup links and footnote in Markdown files')
    
    parser.add_argument('filename', type=str,
                    help='The filename in which to cleanup the links')
    
    args = parser.parse_args()

    # Read in the file and find all the links and references.
    mdFile = open(args.filename, "r")
    text = "".join(mdFile.readlines())
    mdFile.close()

    text = cleanupFootnote(text)
    text = cleanupInlineLink(text) 
    text = cleanupReflink(text)

    # remove excess empty lines
    while text.find("\n\n\n\n\n\n") != -1:
        text = text.replace("\n\n\n\n\n\n", "\n\n\n")

    mdFile = open(args.filename, "w")
    mdFile.write(text)
    mdFile.close()

    print("\nCleanup Done")
