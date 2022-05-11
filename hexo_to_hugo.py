# pip install yaml
# usage: python hexo_to_hugo.py
import os
import re
import yaml

# fill default date with this GMT zone
GMT = '+08:00' # for SG time zone

HEADER_FLAG = '---\n'

def file_lines(fname):
    f = open(fname, "r", encoding='utf-8')
    ret = f.readlines()
    f.close()
    return ret


def parser_head_lines(lines: list[str]) -> list[str]:
    header_lines = list[str]([])
    in_header = False
    for i, line in enumerate(lines):
        if line == HEADER_FLAG:
            if not in_header:
                in_header = True
                continue
            else:  # header end flag founded
                break
        if in_header:
            header_lines.append(line)
    return header_lines


def revise_header_flag(lines):
    revised = False
    if len(lines) == 0:
        return lines, revised
    if lines[0] == HEADER_FLAG:
        return lines, revised
    lines.insert(0, HEADER_FLAG)
    revised = True
    return lines, revised


def revise_header_content(header_lines: list[str]):
    revised = False
    for i, line in enumerate(header_lines):
        # date line
        rdate = re.search(r'date:\s+(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})', line, re.M)
        if rdate:  # date line for need revise to TZ format
            header_lines[i] = f'date: {rdate.group(1)}-{rdate.group(2)}-{rdate.group(3)}T{rdate.group(4)}:{rdate.group(5)}:{rdate.group(6)}{GMT}\n'
            revised = True

    # revise for tags and categories to type list
    header_revised = False
    header = yaml.safe_load(''.join(header_lines))
    if 'categories' in header: # make sure categories are type list
        categories = header['categories']
        if not isinstance(categories, list):
            if categories == None:
                header['categories'] = []
            else:
                header['categories'] = [categories]
            header_revised = True

    if 'tags' in header: # make sure tags are type list
        tags = header['tags']
        if not isinstance(tags, list):
            if tags == None:
                header['tags'] = []
            else:
                header['tags'] = [tags]
            header_revised = True

    if header_revised:
        header_lines = yaml.dump(header, default_flow_style=False, allow_unicode=True).splitlines(True)
        revised = True
    return header_lines, revised


def save_file(fname, lines):
    f = open(fname, 'w', encoding='utf-8', newline='\n')
    f.writelines(lines)
    f.close()


def main():
    HEADER_FLAG = '---\n'
    print('--- starting revise for posts... ---')
    POST_PATH = os.path.join('content', 'posts')
    posts_count = 0
    header_flag_revised_count = 0
    header_revised_count = 0
    files = os.listdir(POST_PATH)
    for fname in files:
        fullpath = os.path.join(POST_PATH, fname)
        if not os.path.isfile(fullpath):
            continue
        lines = file_lines(fullpath)
        lines, header_flag_revised = revise_header_flag(lines)
        if header_flag_revised:
            print(f'revised header flag: {fname}')
            header_flag_revised_count += 1
        header_lines = parser_head_lines(lines)
        body_lines = lines[len(header_lines)+2:]  # skip two header flag lines
        header_lines, header_revised = revise_header_content(header_lines)
        if header_revised:
            print(f'revised date: {fname}')
            header_revised_count += 1
        if header_flag_revised or header_revised:
            print(f'save revised file: {fname}')
            header_lines.insert(0, HEADER_FLAG)
            header_lines.append(HEADER_FLAG)
            save_file(fullpath, header_lines + body_lines)
        posts_count += 1
    print(f'--- revise over. ---\nposts: {posts_count}\nheader flag revised: {header_flag_revised_count}\nheader revised: {header_revised_count}')


if __name__ == "__main__":
    main()
