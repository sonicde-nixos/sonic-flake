# Proposal: a coordinated 6.8 packaging matrix for the NixOS flake

Status: documentation proposal only. This document changes no build inputs,
package expressions, NixOS module options, or system configuration.

## Motivation

The upstream 6.8.0 announcement describes an X11 desktop environment built
independently of KDE Plasma 6 and ready for KDE and Qt applications:

- [SonicDE 6.8.0 released](https://github.com/Sonic-DE/sonic-blogs/blob/master/posts/2026/2026-10-24-sonicde-6-8-0-released.md)
- [Arch Linux package repository](https://sonicde-arch.github.io/)

This flake's README still documents `6.7.1 / 6.27.0`, and its current package
expressions use one directory per component. The 6.8 generation needs a
coordinated update of source tags, framework versions, and dependencies; it is
not a single version bump. [Issue #4](https://github.com/sonicde-nixos/sonic-flake/issues/4)
asks which matrix upstream considers supported. This note proposes a reviewable
packaging process and a small first milestone once that matrix is agreed.

[PR #3](https://github.com/sonicde-nixos/sonic-flake/pull/3) addresses build
compatibility of the existing 6.7.1 flake with a newer nixpkgs. It is a useful
precondition for current builds, but its scope is separate from a 6.8 source
matrix update. This proposal does not modify or supersede that PR.

## Source of truth

1. Upstream confirmation of the supported 6.8 component set and framework
   versions, ideally in issue #4 or an official release branch.
2. The pinned upstream [sonicde-arch](https://github.com/sonicde-arch/sonicde-arch)
   PKGBUILD tree for the matching stable release. It records which patch tags
   and dependency names were tested together.
3. The official [sonicde-meta](https://github.com/sonicde-arch/sonicde-arch/blob/master/sonicde-meta/PKGBUILD)
   dependency list for the minimum complete desktop set. Optional packages are
   listed separately in that file.

"6.8.0" is a coordinated matrix containing patch tags such as `6.8.0.x`,
Frameworks releases, application releases, and Qt binding releases. Pinning
every component to one literal `6.8.0` tag would not reproduce the published
stable set.

## Proposed process

1. Record the exact source repository, tag, and dependency list for each
   component in a machine-readable matrix. Do not infer patch tags from the
   numeric release name.
2. Map Arch package names to nixpkgs or SonicDE flake attributes explicitly.
   Keep a documented list of unmapped names instead of silently dropping build
   dependencies.
3. Reuse this flake's `mk-sonic-drv` conventions and its existing per-component
   package layout where possible. Add new 6.8 component expressions in a
   dedicated branch rather than replacing the 6.7.1 tree in place.
4. Build in layers: framework libraries, desktop libraries, core session
   components, then the NixOS module and a complete system closure. Record the
   flake revision and nixpkgs revision used for each successful build.
5. Preserve the existing `services.desktopManager.sonic-de.enable` module
   contract and package attribute names where upstream 6.8 allows it. Any
   intentional break needs an explicit note in the release documentation.
6. Keep 6.7.1 available as a tagged fallback until a 6.8 branch has a passing
   full-system build and a documented rollback path.

## Proposed first milestone

A small, independently reviewable 6.8 branch containing:

- the agreed matrix and dependency map;
- one framework-library build layer that evaluates and builds cleanly;
- a short status document naming which components are verified, which are
  blocked, and which nixpkgs revision was tested.

A full desktop or system switch is deliberately outside this first milestone.
Subsequent PRs can add the remaining layers in reviewable increments.

## Compatibility guidance

- Do not fake CMake package versions from 6.7.1 to satisfy 6.8 consumers.
  Version checks alone do not provide matching headers, QML modules, or ABIs.
- Avoid one-off downstream shims for a missing SonicDE replacement. If a KDE
  utility genuinely needs a 6.8 interface, use the corresponding 6.8 SonicDE
  component or explicitly document it as unsupported in that release.
- Verify build-time dependency resolution as well as runtime library paths;
  a successful closure can still select mixed KDE/SonicDE development outputs.
- Keep X11/Xlibre as an explicit test target. A Wayland-only verification does
  not cover the screenlocker, window manager, or display-server paths that
  distinguish SonicDE.

## Questions for maintainers

1. Should a 6.8 matrix live in a new branch, a versioned tag, or a
   subdirectory of `master`?
2. Should the 6.8 contribution reuse the current flat package layout, or is a
   matrix-driven package layout preferred?
3. Which nixpkgs generation should the first 6.8 build target?
4. Are the Arch stable PKGBUILD tags the authoritative source list for NixOS,
   or is there another upstream manifest?

This document is intentionally limited to process and acceptance boundaries.
It does not claim that a full 6.8 port has been built or validated here, and it
does not request a merge of generated downstream configuration.
