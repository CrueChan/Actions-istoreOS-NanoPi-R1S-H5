#!/usr/bin/env python3
"""
extract_ko_from_ipk.py
----------------------
Download a list of .ipk packages from an ImmortalWrt package repository and
extract all .ko (kernel module) files into a target directory.

Usage:
    python3 extract_ko_from_ipk.py <base_url> <output_dir> <pkg1_encoded> [pkg2_encoded ...]

    base_url      - Base URL of the package repository
    output_dir    - Directory to copy extracted .ko files into
    pkgN_encoded  - URL-encoded filename of the .ipk package to download
                    (use %2B for + signs in version strings)

Exit codes:
    0 - all packages extracted successfully
    1 - one or more packages failed to download or parse
"""

import sys
import os
import io
import tarfile
import urllib.request
import urllib.error
import tempfile
import shutil


def download_ipk(url: str, dest: str) -> bool:
    """Download a URL to dest. Returns True on success."""
    print(f"  Downloading: {url}")
    try:
        with urllib.request.urlopen(url) as resp, open(dest, "wb") as f:
            shutil.copyfileobj(resp, f)
        size = os.path.getsize(dest)
        print(f"  Downloaded {size:,} bytes")
        return True
    except urllib.error.HTTPError as e:
        print(f"  ERROR: HTTP {e.code} {e.reason}", file=sys.stderr)
        return False
    except Exception as e:
        print(f"  ERROR: {e}", file=sys.stderr)
        return False


def extract_ko_from_ipk(ipk_path: str, output_dir: str) -> int:
    """
    Parse an .ipk file (ar archive containing data.tar.*) and extract all .ko
    files into output_dir.  Returns the number of .ko files extracted.
    """
    extracted = 0
    with open(ipk_path, "rb") as f:
        magic = f.read(8)
        if magic != b"!<arch>\n":
            print(f"  ERROR: Not an ar archive. magic={magic!r}", file=sys.stderr)
            return -1

        while True:
            hdr = f.read(60)
            if not hdr or len(hdr) < 60:
                break
            member_name = hdr[0:16].decode("ascii", errors="replace").strip().rstrip("/")
            size = int(hdr[48:58].decode("ascii").strip())
            data = f.read(size)
            if size % 2:
                f.read(1)  # alignment padding

            print(f"  member: {member_name!r}  ({size:,} bytes)")

            if "data.tar" in member_name:
                buf = io.BytesIO(data)
                try:
                    with tarfile.open(fileobj=buf) as tar:
                        for member in tar.getmembers():
                            if member.name.endswith(".ko"):
                                dest_name = os.path.basename(member.name)
                                member.name = dest_name
                                print(f"    extracting: {dest_name}")
                                tar.extract(member, output_dir)
                                extracted += 1
                except Exception as e:
                    print(f"  tarfile error: {e}", file=sys.stderr)

    return extracted


def main():
    if len(sys.argv) < 4:
        print(__doc__)
        sys.exit(1)

    base_url = sys.argv[1].rstrip("/")
    output_dir = sys.argv[2]
    packages = sys.argv[3:]

    os.makedirs(output_dir, exist_ok=True)

    failures = 0
    total_ko = 0

    for pkg in packages:
        label = pkg.replace("%2B", "+")
        url = f"{base_url}/{pkg}"
        print(f"\n=== {label}")

        with tempfile.TemporaryDirectory() as tmp:
            ipk_path = os.path.join(tmp, "pkg.ipk")
            if not download_ipk(url, ipk_path):
                failures += 1
                continue

            count = extract_ko_from_ipk(ipk_path, output_dir)
            if count < 0:
                failures += 1
            else:
                total_ko += count

    print(f"\n=== Summary: {total_ko} .ko file(s) extracted, {failures} failure(s)")
    sys.exit(1 if failures else 0)


if __name__ == "__main__":
    main()
