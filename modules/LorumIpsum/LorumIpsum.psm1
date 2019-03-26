function New-LorumIpsum {
    Param(
        [int] $CharLength = -1
    )
    $text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur dignissim tortor non sollicitudin fermentum. Aliquam et est et mi consectetur cursus. Ut pellentesque varius orci, quis lacinia eros dictum nec. Donec blandit rutrum leo. Vestibulum cursus vulputate velit a tincidunt. Nam mattis iaculis faucibus. Nam orci enim, feugiat at molestie sed, tincidunt et sapien. Etiam hendrerit risus ullamcorper sapien convallis, sit amet sodales nulla elementum. Interdum et malesuada fames ac ante ipsum primis in faucibus. Phasellus gravida, justo non pretium fermentum, tellus felis vehicula felis, et iaculis nisl sem feugiat justo.
    Integer enim augue, convallis quis vehicula sit amet, finibus non nunc. Aliquam interdum nunc ac ligula malesuada venenatis. Mauris ut ante purus. Curabitur massa tellus, ornare non condimentum in, malesuada quis justo. Donec neque velit, posuere ut dapibus vitae, ullamcorper et enim. Maecenas varius neque eu metus tristique rutrum. Vestibulum nec magna nec quam luctus euismod. In scelerisque sem ac tellus ultricies mollis. Pellentesque dictum, metus id tempor euismod, metus lorem fermentum augue, a aliquam sem mi vitae tellus. Suspendisse at tortor dignissim leo congue ultricies. Vestibulum arcu turpis, suscipit at eros interdum, faucibus volutpat magna. Morbi nec feugiat sem. Aliquam erat volutpat. Nulla facilisi.
    Vivamus a iaculis dui. Nulla faucibus luctus enim, ac ultricies mauris suscipit vel. Donec quis ultricies lorem. Donec dapibus faucibus justo id hendrerit. Quisque viverra at arcu id pellentesque. Etiam sed mi facilisis, suscipit sem eu, scelerisque purus. Aliquam mattis nisi id enim egestas, vitae hendrerit ante pharetra. Suspendisse suscipit finibus mi non eleifend. Cras odio metus, suscipit vitae nisi eget, laoreet auctor urna. Nullam metus ex, lacinia sollicitudin tincidunt eget, dignissim quis enim. Integer venenatis luctus tellus, non aliquet urna fermentum quis. Cras eu hendrerit sapien. Nam pellentesque faucibus nisi, nec ullamcorper ex imperdiet quis. Integer laoreet nisl ac tristique venenatis. In consequat dui a pharetra congue.
    Etiam id dictum neque, et posuere metus. Etiam facilisis eget diam in finibus. Nullam eget sem lacinia, blandit elit quis, dapibus est. Sed commodo consectetur leo, eu ultricies velit imperdiet eu. Sed pharetra nisl id ante sagittis pellentesque. Cras luctus varius dolor eget ullamcorper. Nullam nec est congue, posuere ligula nec, lobortis felis. Aenean at lobortis mi.
    Pellentesque facilisis ultrices enim a ultricies. Duis quis risus vel tortor consectetur condimentum. Nulla nec magna at magna pharetra bibendum. Curabitur suscipit convallis orci ut pretium. Nunc semper purus bibendum eros laoreet efficitur. In venenatis turpis lorem, vitae elementum mauris egestas egestas. Ut efficitur lobortis massa eget pellentesque. Curabitur et fermentum turpis, id consectetur dolor. Duis ut ultrices purus. Curabitur id scelerisque orci. Sed lectus leo, consectetur eget molestie bibendum, sollicitudin a felis. Sed magna est, condimentum ac nisl sit amet, gravida tincidunt lectus. Pellentesque id enim varius, consequat ipsum a, accumsan mi."

    if ($CharLength -gt 0 -and $CharLength -lt $text.Length){
        $out = $text.Substring(0, $CharLength) 
    } else {
        $out = $text
    }

    $out | clip
    return $out
}

Export-ModuleMember New-LorumIpsum