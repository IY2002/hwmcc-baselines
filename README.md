# hwmcc-baselines

A container image with open-source hardware model checkers at pinned versions, for running HWMCC-style benchmarks.

```
docker pull ghcr.io/iy2002/hwmcc-baselines:latest
```

Contents:
- [rIC3](https://github.com/gipsyh/rIC3) v1.5.2, built from source
- [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) 2026-11-18, which includes Yosys, SBY, ABC (`yosys-abc`), Pono, btormc, Bitwuzla, AVY and others

Each tool keeps its own license; see the upstream projects.
