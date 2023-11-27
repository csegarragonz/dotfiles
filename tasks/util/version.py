def get_version():
    with open(join(PROJ_ROOT, "VERSION"), "r") as fh:
        version = fh.read()
        version = version.strip()
    return version
