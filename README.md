# scrylab-matlab

[![View ScryLab Plotter on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/184152-scrylab-plotter)

MATLAB wrapper for the [ScryLab](https://scrylab.de) REST API. Lets you plot signals directly in a running ScryLab GUI from any MATLAB environment – scripts or simulation pipelines – as a faster, more interactive alternative to MATLAB figures for exploratory signal analysis.

## What you can do

- Send 1D signals (time series, measurement channels, …) into ScryLab's data browser
- Send ~~colored lines (signal + scalar color axis)~~ (coming soon) or spectrograms (2D matrix)
- Convenience function: open signals directly in a plot from code

## Requirements

- MATLAB R2023a or later
- ScryLab desktop app running on the same machine ([Installation Guide](https://docs.scrylab.de/docs/getting-started/installation/))

## Installation

Download `ScryLab.mltbx` from [Releases](https://github.com/scrylab/scrylab-matlab/releases) and double-click to install, **or** add the folder that *contains* the `+scry` package to your MATLAB path (not the `+scry` folder itself):

```matlab
addpath('/path/to/scrylab-matlab')
```

All functions live in the `scry` namespace – call them as `scry.send`, `scry.plot`, `scry.send_many`.

## Quick start

```matlab
t = linspace(0, 10, 1000);
y = sin(2*pi*5*t);

% Send + plot in one step
scry.plot(y, name="Example Signal", x=t, y_unit="V", x_unit="s")

% Or send without plotting – drag from the data browser manually
scry.send(y, name="Example Signal", x=t, y_unit="V", x_unit="s")

% Overwrite an existing signal
scry.send(y*2, name="Example Signal", x=t, y_unit="V", x_unit="s", overwrite=true)
```

## API

### `scry.send(y, Name=Value, …)`

Send a single signal to ScryLab without opening a plot.

```matlab
scry.send(y, name="Speed", source="Testrun 01", x=t, y_unit="km/h", x_unit="s")
```

| Parameter | Description |
|-----------|-------------|
| `y` | Numeric vector or matrix (required) |
| `name` | Signal name (auto-generated if omitted) |
| `source` | [Data source](https://docs.scrylab.de/docs/concepts/data-sources/) to send into, default `"Sent from API"`; created automatically if it doesn't exist |
| `x` | X-axis values; auto-generated if omitted |
| `z` | ~~Color axis (1D vector)~~ (coming soon) or spectrogram (2D matrix) |
| `y_unit`, `x_unit`, `z_unit` | Axis units, e.g. `"V"`, `"s"`, `"Hz"` |
| `overwrite` | Replace an existing signal with the same name (default: `false`) |

### `scry.send_many(y, Name=Value, …)`

Send multiple signals at once. `y` must be a cell array of numeric arrays.

```matlab
scry.send_many( ...
    {channel_1, channel_2, channel_3}, ...
    names={"Speed", "RPM", "Torque"}, ...
    y_unit={"km/h", "1/min", "Nm"}, ...
    source="Testrun 02")
```

| Parameter | Description |
|-----------|-------------|
| `y` | Cell array of numeric arrays – one cell per signal |
| `names` | Cell array of signal names; auto-generated if omitted |
| `source` | Data source (same as `scry.send`) |
| `x` | Single x-axis vector broadcast to all signals, or a cell array (one per signal) |
| `z` | ~~1D colored trace~~ (coming soon) or 2D spectrogram – single value broadcast to all, or cell array (one per signal) |
| `y_unit`, `x_unit`, `z_unit` | Single string broadcast to all, or cell array (one per signal) |
| `overwrite` | Replace existing signals with the same name (default: `false`) |

### `scry.plot(y, Name=Value, …)`

Same as `scry.send` but also opens the signal in a plot. Always uses `"Sent from API"` as the data source.

## Spectrograms

Pass a 2D matrix as `z`. Columns map to the x-axis (e.g. time), rows to the y-axis (e.g. frequency).

The example below needs the Signal Processing Toolbox for `spectrogram`:

```matlab
fs = 1000;                          % Hz
t  = linspace(0, 4, fs*4);

% 20 Hz for the first 2 s, then 80 Hz
y         = sin(2*pi*20*t);
y(t >= 2) = sin(2*pi*80*t(t >= 2));

[s, f, t_bins] = spectrogram(y, 256, 192, 256, fs);
z = 20*log10(abs(s) + 1e-12);       % [n_freq × n_time], magnitude in dB

scry.send(f, z=z, name="Spectrogram", x=t_bins, y_unit="Hz", x_unit="s", z_unit="dB")
```

**No toolbox? Let ScryLab do it.** Send the raw 1D signal and apply the built-in **STFT**
operation in the app – no client-side computation needed:

```matlab
scry.send(y, name="Vibration", x=t, y_unit="V", x_unit="s")
% then right-click the signal in ScryLab → Operations… → STFT
```

## Running tests

With the folder containing `+scry` on the path:

```matlab
results = runtests('scry.ScryLabTest');
disp(results)
```