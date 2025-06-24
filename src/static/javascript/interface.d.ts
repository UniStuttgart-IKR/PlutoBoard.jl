interface JuliaFunctionOptions {
    args?: any[];
    kwargs?: Record<string, any>;
    response_callback?: (response: any) => void;
    internal?: boolean;
}

export declare function callJuliaFunction(
    func_name: string,
    options?: JuliaFunctionOptions
): Promise<any>;

export declare function placeAlliFrames(): void;

export declare function updateCellByVariable(varname: string): void;